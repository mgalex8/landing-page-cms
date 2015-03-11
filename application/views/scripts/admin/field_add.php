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
                <td class="span2"><?php echo __('ID'); ?>*:</td>
                <td><input type="text" name="name" value="<?php echo $result['field']['name']; ?>" /></td>
            </tr>
            <tr>
                <td class="span2"><?php echo __('Name'); ?>*:</td>
                <td><input type="text" name="title" value="<?php echo $result['field']['title']; ?>" /></td>
            </tr>           
            <tr>
                <td class="span2"><?php echo __('i18n'); ?>:</td>
                <td><input type="text" name="i18n" value="<?php echo $result['field']['i18n']; ?>" /></td>                    
            </tr>
            <tr>
                <td class="span2"><?php echo __('Parameter'); ?> 1:</td>
                <td><input type="text" name="param1" value="<?php echo $result['field']['param1']; ?>" /></td>                    
            </tr>
            <tr>
                <td class="span2"><?php echo __('Parameter'); ?> 2:</td>
                <td><input type="text" name="param2" value="<?php echo $result['field']['param2']; ?>" /></td>                    
            </tr>
            <tr>
                <td class="span2"><?php echo __('Multiply'); ?>:</td>
                <td><input type="checkbox" name="multiply" <?php if ($result['field']['multiply']){ echo "checked"; } ?>" /></td>                    
            </tr>
            <tr>
                <td class="span2" colspan="2">&nbsp</td>
            </tr>
            <tr>
                <td class="span2"></td>
                <td><input type="submit" class="btn btn-success" value="<?php echo $result['title']; ?>" /></td>
            </tr>
        </table>          
        <input type="hidden" name="structure_id" value="<?php echo $result['field']['structure_id']; ?>" />
    </form>
<div>