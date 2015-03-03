<h2><?php echo __('Users') ?></h2>
<div class="row space">
    <div class="span12 ">                
        <a class="btn btn-success" href="<?php echo $result['add_url']; ?>"><i class="icon-ok icon-white"></i> <?php echo __('Add'); ?></a>        
        <a class="btn btn-danger remove-btn"><i class="icon-remove icon-white"></i> <?php echo __('Delete selected'); ?></a>
    </div>    
</div>
<div class="row space">
    <div class="span12">
        <form id="delete-form" method="POST">
            <table class="table table-striped table-hover" id="user-table">
                <thead>
                    <tr>
                        <th class="span1 text-center"><input type="checkbox" /></th>
                        <th class="span3"><?php echo __('Username'); ?></th>
                        <th class="span2"><?php echo __('Email'); ?></th>
                        <th class="span2"><?php echo __('Last login'); ?></th>
                        <th class="span2"><?php echo __('Date create'); ?></th>
                        <th class="span2"></th>
                    </tr>
                </thead>
                <tbody>
                    <?php
                        foreach ($result['users'] as $user):
                    ?>
                            <tr id="user_<?php echo $user['id']; ?>">
                                <td class="text-center"><input type="checkbox" name="delete[<?php echo $user['id']; ?>]" userid="<?php echo $user['id']; ?>" /></td>
                                <td><?php echo $user['username']; ?></td>
                                <td><?php echo $user['email']; ?></td>
                                <td><?php echo $user['last_login']; ?></td>
                                <td><?php echo $user['created']; ?></td>
                                <td class="text-center">
                                    <a class="btn btn-success" href="<?php echo $result['edit_url']; ?>?id=<?php echo $user['id'] ;?>"><i class="icon-pencil icon-white"></i></a>        
                                    <a class="btn btn-danger remove-image-btn" item-id="<?php echo $user['id']; ?>"><i class="icon-remove icon-white"></i></a>
                                </td>
                            </tr>
                    <?php
                        endforeach;
                    ?>
                </tbody>
            </table>
        </form>
    </div>
</div>

<?php echo $pagination; ?>

<br/>

<script>
    jQuery(document).ready(function(){
        jQuery('.selectpicker').selectpicker();
        
        jQuery(function(){
            jQuery('.edit-btn').each(function(){
                var _self = jQuery(this);
                    tr = _self.closest('tr');
                    td = _self.closest('td');
                td.css({'height': (_self.height()+10)+'px'});
                _self.hide();
                tr.on('mouseover',function(){
                    _self.show();
                });
                tr.on('mouseout',function(){
                    _self.hide();
                });
            });    
        });
        
        var checkboxes = jQuery('td input[type=checkbox]'),
            disabling = function(){
                if (checkboxes.filter(':checked').length === 0){
                    jQuery('.remove-btn').addClass('disabled');
                    jQuery('.block-btn').addClass('disabled');
                    jQuery('.activate-btn').addClass('disabled');
                }
                else {
                    jQuery('.remove-btn').removeClass('disabled');
                    jQuery('.block-btn').removeClass('disabled');
                    jQuery('.activate-btn').removeClass('disabled');
                }                
            };
        jQuery('td input[type=checkbox]').on('change',function(){
            console.log(this);
            disabling();
        });
        
        jQuery(function(){
            jQuery('th input[type=checkbox]').on('change',function(){
                if (jQuery(this).is(':checked')){
                    jQuery('td input[type=checkbox]').prop('checked',true);
                }
                else{
                    jQuery('td input[type=checkbox]').prop('checked',false);
                }
                disabling();
            });
        });
        disabling();        
        
        jQuery('.remove-btn').on('click', function(){
            if ( !jQuery(this).is('.disabled')) {
                jQuery('#delete-form').submit();
            }
        });
        
        jQuery('.block-btn').on('click', function(){
            jQuery('td input[type=checkbox]').each(function(){                
                var userid = jQuery(this).attr('userid');
                if (jQuery(this).is(':checked')) {                    
                    jQuery.ajax({
                        url:'/admin/Json/user_block/',                    
                        dataType:'html',
                        data:{
                            id: userid,
                            action: 'block',
                        },
                        success: function(response){
                            //console.log(response);                            
                            jQuery('#user-table #user_'+userid).html(response);
                        }
                    });
                }    
            });
        });
        
        jQuery('.activate-btn').on('click', function(){
            jQuery('td input[type=checkbox]').each(function(){
                var userid = jQuery(this).attr('userid');                
                if (jQuery(this).is(':checked')) {
                    jQuery.ajax({
                        url:'/admin/Json/user_block/',                    
                        dataType:'html',
                        data:{
                            id: userid,
                            action: 'activate',
                        },
                        success: function(response){
                            //console.log(response);
                            jQuery('#user-table #user_'+userid).html(response);
                        }
                    });
                }
            });
        });        
        
    });
</script>