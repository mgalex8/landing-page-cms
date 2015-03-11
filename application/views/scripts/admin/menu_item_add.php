<h2><?php echo $result['title']; ?></h2>
<div class="span12" style="padding:40px">    
    <form action="<?php echo $result['action_url']; ?>" method="post">        
        <table>
            <tr>
                <td class="span2"></td>
                <td><div class="error errors">                        
                        <?php
                            foreach ($result['errors'] as $err)
                            {
                                echo '<div>' . $err . '</div>';
                            }    
                        ?>
                    </div></td>
            </tr>                                
            <tr>
                <td class="span2"><?php echo __('Name'); ?>*:</td>
                <td><input type="text" name="name" value="<?php echo $result['menu_item']['name']; ?>" /></td>
            </tr>           
            <tr>
                <td class="span2"><?php echo __('i18n'); ?>:</td>
                <td><input type="text" name="i18n" value="<?php echo $result['menu_item']['i18n']; ?>" /></td>                    
            </tr>
            <tr>
                <td class="span2"><?php echo __('Href'); ?>:</td>
                <td><input type="text" name="href" value="<?php echo $result['menu_item']['href']; ?>" /></td>                    
            </tr>
            <tr>
                <td class="span2"><?php echo __('Route'); ?>:</td>
                <td><input type="text" name="route" value="<?php echo $result['menu_item']['route']; ?>" /></td>                    
            </tr>     
            <tr>
                <td class="span2"><?php echo __('Controller'); ?>:</td>
                <td><input type="text" name="controller" value="<?php echo $result['menu_item']['controller']; ?>" /></td>                    
            </tr>
            <tr>
                <td class="span2"><?php echo __('Action'); ?>:</td>
                <td><input type="text" name="action" value="<?php echo $result['menu_item']['action']; ?>" /></td>                    
            </tr>
            <tr>
                <td class="span2"><?php echo __('Query string'); ?>:</td>
                <td><input type="text" name="qs" value="<?php echo $result['menu_item']['qs']; ?>" /></td>                    
            </tr>
            <tr>
                <td class="span2"><?php echo __('Classes'); ?>:</td>
                <td><input type="text" name="classes" value="<?php echo $result['menu_item']['classes']; ?>" /></td>                    
            </tr>
            <tr>
                <td class="span2" colspan="2">&nbsp</td>
            </tr>
            <tr>
                <td class="span2"></td>
                <td><input type="submit" class="btn btn-success" value="<?php echo $result['title']; ?>" /></td>
            </tr>
        </table>          
        <input type="hidden" name="type_id" value="<?php echo $result['menu_item']['type_id']; ?>" />
    </form>
<div>